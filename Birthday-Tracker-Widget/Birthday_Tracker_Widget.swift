//
//  Birthday_Tracker_Widget.swift
//  Birthday-Tracker-Widget
//
//  Created by Foggin, Oliver (Developer) on 15/09/2021.
//

import WidgetKit
import SwiftUI
import Intents
import Common
import ComposableArchitecture
import FileClient

struct WidgetState: Equatable {
  var people: IdentifiedArrayOf<Person> = []
}

enum WidgetAction {
  case onAppear
  case loadData
  case loadResults(Result<[Person], Never>)
}

struct WidgetEnvironment {
  var fileClient: FileClient
  var fileName: String
}

extension WidgetEnvironment {
  static var live: Self = .init(
    fileClient: .live,
    fileName: "file.json"
  )
}

let widgetReducer = Reducer<WidgetState, WidgetAction, WidgetEnvironment> {
  state, action, environment in
  
  switch action {
  case .onAppear:
    return Effect(value: .loadData)
    
    // Loading data
  case .loadData:
    return environment.fileClient
      .load(environment.fileName)
      .catchToEffect(WidgetAction.loadResults)
  case let .loadResults(.success(people)):
    if !people.isEmpty {
      state.people = people.identified
    }
    return .none
  }
}
  .debug()

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
  var entry: Provider.Entry
  
  var body: some View {
    WithViewStore(store) { viewStore in
      ForEach(viewStore.people) { person in
        List {
          HStack {
            Text(person.name)
            Spacer()
            Text(person.nextBirthday(now: Date(), calendar: .current), style: .date)
          }
        }
        .padding()
      }
      .onAppear { viewStore.send(.onAppear) }
    }
  }
}

@main
struct Birthday_Tracker_Widget: Widget {
  let kind: String = "Birthday_Tracker_Widget"
  
  var body: some WidgetConfiguration {
    IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
      Birthday_Tracker_WidgetEntryView(
        store: Store(
          initialState: .init(),
          reducer: widgetReducer,
          environment: .live
        ),
        entry: entry
      )
    }
    .configurationDisplayName("My Widget")
    .description("This is an example widget.")
  }
}

struct Birthday_Tracker_Widget_Previews_Small: PreviewProvider {
  static var previews: some View {
    let testPeople: IdentifiedArrayOf<Person> = [
      Person(id: UUID(), name: "Oliver", dob: Date(timeIntervalSince1970: 1000000)),
      Person(id: UUID(), name: "Bob", dob: Date(timeIntervalSince1970: 200000))
    ]
    
    Birthday_Tracker_WidgetEntryView(
      store: Store(
        initialState: .init(
          people: testPeople
        ),
        reducer: widgetReducer,
        environment: .live
      ),
      entry: SimpleEntry(
        date: Date(),
        configuration: ConfigurationIntent()
      )
    )
      .previewContext(
        WidgetPreviewContext(family: WidgetFamily.systemSmall)
      )
  }
}

struct Birthday_Tracker_Widget_Previews_Medium: PreviewProvider {
  static var previews: some View {
    let testPeople: IdentifiedArrayOf<Person> = [
      Person(id: UUID(), name: "Oliver", dob: Date(timeIntervalSince1970: 2000000)),
      Person(id: UUID(), name: "Bob", dob: Date(timeIntervalSince1970: 200000))
    ]
    
    Birthday_Tracker_WidgetEntryView(
      store: Store(
        initialState: .init(
          people: testPeople
        ),
        reducer: widgetReducer,
        environment: .live
      ),
      entry: SimpleEntry(
        date: Date(),
        configuration: ConfigurationIntent()
      )
    )
      .previewContext(
        WidgetPreviewContext(family: WidgetFamily.systemMedium)
      )
  }
}
