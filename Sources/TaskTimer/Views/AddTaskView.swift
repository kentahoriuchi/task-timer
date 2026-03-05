import SwiftUI

struct AddTaskView: View {
    @EnvironmentObject var taskManager: TaskManager
    @Binding var isPresented: Bool
    @State private var taskName = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: 16) {
            Text("Add Task")
                .font(.headline)

            TextField("Task name", text: $taskName)
                .textFieldStyle(.roundedBorder)
                .focused($isFocused)
                .onSubmit { create() }

            HStack {
                Button("Cancel") {
                    isPresented = false
                }
                .keyboardShortcut(.cancelAction)

                Spacer()

                Button("Create") {
                    create()
                }
                .keyboardShortcut(.defaultAction)
                .disabled(taskName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .padding()
        .frame(width: 280)
        .onAppear { isFocused = true }
    }

    private func create() {
        taskManager.addTask(name: taskName)
        isPresented = false
    }
}
