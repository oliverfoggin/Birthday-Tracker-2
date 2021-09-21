//
//  Birthday_Tracker_Widget.swift
//  Birthday-Tracker-Widget
//
//  Created by Foggin, Oliver (Developer) on 15/09/2021.
//

import WidgetKit
import SwiftUI
import Intents
import ComposableArchitecture
import Common
import FileClient

struct Provider: IntentTimelineProvider {
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), configuration: ConfigurationIntent())
  }
  
  func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    let entry = SimpleEntry(date: Date(), configuration: configuration)
    completion(entry)
  }
  
  func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    var entries: [SimpleEntry] = []
    
    // Generate a timeline consisting of five entries an hour apart, starting from the current date.
    let currentDate = Date()
    for hourOffset in 0 ..< 5 {
      let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
      let entry = SimpleEntry(date: entryDate, configuration: configuration)
      entries.append(entry)
    }
    
    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let configuration: ConfigurationIntent
}

struct Birthday_Tracker_WidgetEntryView : View {
  let store: Store<WidgetState, WidgetAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      ZStack {
        Color("WidgetBackground")
        VStack(alignment: .leading) {
          ForEach(viewStore.people) { person in
            VStack(alignment: .leading) {
              Text(person.name)
                .foregroundColor(Color("TextColor"))
              Text(person.nextBirthday(now: Date(), calendar: .current), style: .date)
                .font(.caption)
                .foregroundColor(Color("TextColor"))
              Text(person.nextBirthday(now: Date(), calendar: .current), style: .relative)
                .font(.caption)
                .foregroundColor(Color("TextColor"))
              
            }
            .padding(.all, 6.0)
            .background(ContainerRelativeShape().fill().foregroundColor(Color("AccentColor")))
          }
        }
        .padding()
        .onAppear { viewStore.send(.onAppear) }
      }
    }
  }
}

@main
struct Birthday_Tracker_Widget: Widget {
  let kind: String = "Next_Birthdays_Widget"
  
  var body: some WidgetConfiguration {
    IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
      Birthday_Tracker_WidgetEntryView(
        store: Store(
          initialState: .init(),
          reducer: widgetReducer,
          environment: .live
        )
      )
    }
    .configurationDisplayName("Next birthdays")
    .description("This is an example widget.")
  }
}

let previewPeople: [Person] = [
  Person(id: UUID(), name: "Oliver", dob: Date(timeIntervalSince1970: 2000000)),
  Person(id: UUID(), name: "Bob", dob: Date(timeIntervalSince1970: 50000000)),
//  Person(id: UUID(), name: "Dave", dob: Date(timeIntervalSince1970: 30000000)),
]

extension WidgetEnvironment {
  static var preview: Self = .init(
    fileEnvironment: FileEnvironment(
      fileClient: FileClient(
        save: { _, _ in Effect.none },
        load: { _ in Effect(value: previewPeople) }
      ),
      fileName: ""
    )
  )
}

struct Birthday_Tracker_Widget_Previews: PreviewProvider {
  static var previews: some View {
    Group {
        Birthday_Tracker_WidgetEntryView(
          store: Store(
            initialState: .init(people: previewPeople.identified),
            reducer: widgetReducer,
            environment: .preview
          )
        )
          .previewContext(
            WidgetPreviewContext(family: WidgetFamily.systemMedium)
          )
      
      Birthday_Tracker_WidgetEntryView(
        store: Store(
          initialState: .init(people: previewPeople.identified),
          reducer: widgetReducer,
          environment: .preview
        )
      )
        .previewContext(
          WidgetPreviewContext(family: WidgetFamily.systemSmall)
        )
      
      Birthday_Tracker_WidgetEntryView(
        store: Store(
          initialState: .init(people: previewPeople.identified),
          reducer: widgetReducer,
          environment: .preview
        )
      )
        .previewContext(
          WidgetPreviewContext(family: WidgetFamily.systemSmall)
        )
    }
  }
}
