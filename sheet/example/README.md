# sheet example

Demonstrates [CupertinoSheetRoute](https://pub.dev/packages/sheet) use cases.

## Run

```sh
cd sheet/example
flutter pub get
flutter run
```

## Cases

| Demo | API |
|------|-----|
| Full sheet | default `initialStop: 1`, `SheetFit.expand` |
| Fit content | `fit: SheetFit.loose` |
| Half height on open | `initialStop: 0.5` |
| Snap stops | `stops: [0, 0.4, 1]` |
| Non-draggable | `draggable: false` |
| Scrollable list | `PrimaryScrollController` |
| Sheet inside sheet | nested `CupertinoSheetRoute` |
| Nested Navigator | inner `Navigator` |
| PopScope | confirm before dismiss |
| Extended route + sheet | `CupertinoExtendedPageRoute` / `MaterialExtendedPageRoute` |
| Declarative API | `CupertinoSheetPage` |
| go_router | `MaterialExtendedPage` + `CupertinoSheetPage` in `pageBuilder` |

## go_router

See [`lib/pages/go_router_sheet_page.dart`](lib/pages/go_router_sheet_page.dart):

- `/` — list with `MaterialExtendedPage` (parallax behind sheet)
- `/book/:bookId` — detail with `CupertinoSheetPage`
- `/book/:bookId/notes` — nested sheet
- `/sheet-fit`, `/sheet-half`, `/sheet-stops` — `ConfiguredCupertinoSheetPage` with `fit` / `initialStop` / `stops`
- `/sheet-navigator` — **one `GoRouter`**, inner pages via **`ShellRoute`** (`parentNavigatorKey` + shell `navigatorKey`)
- `/sheet-navigator/detail/:id` — detail inside the sheet shell (URL updates, same router)
- Wrap shell `child` with [`SheetPrimaryScrollScope`](../../lib/src/widgets/sheet_primary_scroll_scope.dart) so `ListView` uses the sheet scroll controller
