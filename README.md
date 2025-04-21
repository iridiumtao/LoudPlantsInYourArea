#  Loud Plants in Your Area

## Project Architecture
```
LoudPlants/
├─ LoudPlantsApp.swift              # App Entry，Create EnvironmentObjects & NavigationStack
├─ AppCoordinator.swift             # 
│
├─ Models/
│   └─ Plant.swift                  # Plant data struct: id、modelName、status、anchorID…
│
├─ ViewModels/
│   ├─ PlantStore.swift             # ObservableObject: save all plants, fetch API update
│   ├─ DemoViewModel.swift          # DemoView logic: showPicker、showSettings、proximity
│   └─ SettingsViewModel.swift      # SettingsView logic
│
├─ Services/
│   ├─ APIClient.swift              # HTTP request encapsulation（URLSession + Combine）
│   ├─ PlantStatusService.swift     # 
│   └─ ARSessionManager.swift       # ARKit／RealityKit session management, raycast, add anchor
│
├─ Views/
│   ├─ WelcomeView.swift            # Home page: App name / description ＋ "Go to Demo" button
│   ├─ DemoView.swift               # AR Main page: includes ARViewContainer + picker + settings button
│   ├─ SettingsView.swift           # Setting page: to be done
│   ├─ PlantPickerView.swift        # AR entity selection: Grid of thumbnails
│   └─ PlantStatusOverlayView.swift # Float window when the user approach the plant
│
└─ AR/
    └─ ARViewContainer.swift        # UIViewRepresentable or RealityView, render ARView
```
## MVVM Basic
You (ViewController) are going to school, your mom (Coordinator) wakes you up (init ViewController), prepares your lunch (dependencies/services) and put your homework (dependencies/services) inside your backpack (viewModel). She puts the backpack (viewModel) on your back . And send you off to school.

[MVVM+Coordinators IOS Architecture Tutorial](https://medium.com/nerd-for-tech/mvvm-coordinators-ios-architecture-tutorial-fb27eaa36470)
