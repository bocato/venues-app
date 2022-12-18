.PHONY: clean environment update_strings

clean:
	rm -rf -f ~/Library/Developer/Xcode/DerivedData
	xcodebuild clean -workspace /Application/VenuesApp.xcodeproj -scheme App 

environment:
	brew install swiftlint || true
	brew install swiftformat || true
	brew install swiftgen || true

update_strings:
	cd Application/Modules/Core/Localization/Configuration; swiftgen;

code_beautify:
	cd Application; swiftformat ./; swiftlint autocorrect;