# Component Reusability & Code Extraction Strategy ♻️

OpenTrail enforces a strict code reusability framework to maintain a clean, maintainable codebase, eliminate duplication, and preserve UI/UX excellence.

---

## 1. The 11 Core Reusability Rules

1. **Reuse Before Creating**: Developers and AI agents must always check for existing components and utility classes before implementing new code.
2. **Search First**: Search `lib/core/` using `find_files` or `grep` prior to writing any new widget or helper method.
3. **Extract Repeated UI**: If a UI layout pattern or widget structure is used in 2 or more screens, it must be extracted into a reusable component under `lib/core/widgets/`.
4. **Extract Repeated Logic**: Repeated presentation or business logic must be extracted into single-purpose helper services, formatters, or extension methods.
5. **No Monolithic Utils**: Prohibit dumping generic code into files named `utils.dart` or `helpers.dart`.
6. **Single-Purpose Utilities**: Keep utility classes small, strongly typed, and focused on a single domain task (e.g., `date_formatter.dart`, `distance_calculator.dart`).
7. **Prefer Composition Over Inheritance**: Build complex cards by composing smaller base components (`AppCard`, `AppBadge`, `AppRating`, `AppButton`).
8. **Avoid Copy-Paste Implementations**: Duplicating widget or logic blocks across feature modules is strictly forbidden.
9. **Feature-Scoped Widgets**: Widgets specific to a single feature domain must remain scoped inside `lib/features/<feature_name>/presentation/widgets/`.
10. **Truly Shared Widgets**: Truly shared widgets used across multiple feature modules belong in `lib/core/widgets/`.
11. **Avoid Premature Generalization**: Do not add unnecessary abstraction parameters or flags to a component until actual multi-screen usage requires it.

---

## 2. Naming Conventions Across Architectural Layers

| Architecture Element | Naming Convention | Example File | Example Class / Symbol |
| :--- | :--- | :--- | :--- |
| **Shared Core Widgets** | Prefix `App` + `PascalCase` | `app_button.dart` | `AppButton` |
| **Feature-Scoped Widgets** | Feature/Domain Name + `PascalCase` | `explore_destination_card.dart` | `ExploreDestinationCard` |
| **Extensions** | Type/Target + `X` or `Extension` | `build_context_x.dart` | `BuildContextX` |
| **Utilities** | Task + `PascalCase` | `distance_calculator.dart` | `DistanceCalculator` |
| **Formatters** | Target + `Formatter` | `date_formatter.dart` | `DateFormatter` |
| **Validators** | Input + `Validator` | `date_range_validator.dart` | `DateRangeValidator` |
| **Mappers / Converters** | Model + `Mapper` or `DtoX` | `destination_dto_mapper.dart` | `DestinationDtoMapper` |
| **Domain Entities / Models** | Noun Entity `PascalCase` | `destination.dart` | `Destination` |
| **Repositories** | Entity + `Repository` / `RepositoryImpl` | `weather_repository.dart` | `WeatherRepositoryImpl` |
| **Services** | Service Name + `Service` / `ServiceImpl` | `open_meteo_service.dart` | `OpenMeteoServiceImpl` |
| **ViewModels** | Feature/Screen + `ViewModel` | `explore_view_model.dart` | `ExploreViewModel` |

---

## 3. Code Extraction Workflow

When working on OpenTrail features, follow this decision matrix when introducing new UI or logic:

```
                  [Need new UI or Logic?]
                             │
                             ▼
            [Does a similar component exist?]
            ├─── YES ──> [Use existing component]
            │
            └─── NO ───> [Is it used across multiple features?]
                            ├─── YES ──> [Create in lib/core/widgets/ or lib/core/utils/]
                            └─── NO  ──> [Create in lib/features/<feature>/...]
```
