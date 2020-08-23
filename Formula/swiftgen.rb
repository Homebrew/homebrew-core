class Swiftgen < Formula
  desc "Swift code generator for assets, storyboards, Localizable.strings, …"
  homepage "https://github.com/SwiftGen/SwiftGen"
  url "https://github.com/SwiftGen/SwiftGen.git",
      tag:      "6.3.0",
      revision: "f79fa84e7088cdcadf43c69cd1f4e96d996ce171"
  license "MIT"
  head "https://github.com/SwiftGen/SwiftGen.git", branch: "develop"

  bottle do
    cellar :any
    sha256 "8bcb52fa2749827b28c38658154d45129005a9573f3ba53a8997aedf0043a7c5" => :catalina
  end

  depends_on "ruby" => :build if MacOS.version <= :sierra
  depends_on xcode: ["11.4", :build]

  def install
    # Disable swiftlint build phase to avoid build errors if versions mismatch
    ENV["NO_CODE_LINT"] = "1"

    # Install bundler, then use it to `rake cli:install` SwiftGen
    ENV["GEM_HOME"] = buildpath/"gem_home"
    system "gem", "install", "bundler"
    ENV.prepend_path "PATH", buildpath/"gem_home/bin"
    system "bundle", "install", "--without", "development", "release"
    system "bundle", "exec", "rake", "cli:install[#{bin},#{lib},#{pkgshare}/templates]"

    fixtures = {
      "Tests/Fixtures/Resources/Colors/colors.xml"                           => "colors.xml",
      "Tests/Fixtures/Resources/CoreData/Model.xcdatamodeld"                 => "Model.xcdatamodeld",
      "Tests/Fixtures/Resources/Fonts"                                       => "Fonts",
      "Tests/Fixtures/Resources/JSON"                                        => "JSON",
      "Tests/Fixtures/Resources/IB-iOS"                                      => "IB-iOS",
      "Tests/Fixtures/Resources/Plist/good"                                  => "Plist",
      "Tests/Fixtures/Resources/Strings/Localizable.strings"                 => "Localizable.strings",
      "Tests/Fixtures/Resources/XCAssets"                                    => "XCAssets",
      "Tests/Fixtures/Resources/YAML/good"                                   => "YAML",
      "Tests/Fixtures/Generated/Colors/swift5/defaults.swift"                => "colors.swift",
      "Tests/Fixtures/Generated/CoreData/swift5/defaults.swift"              => "coredata.swift",
      "Tests/Fixtures/Generated/Fonts/swift5/defaults.swift"                 => "fonts.swift",
      "Tests/Fixtures/Generated/IB-iOS/scenes-swift5/all.swift"              => "ib-scenes.swift",
      "Tests/Fixtures/Generated/JSON/runtime-swift5/all.swift"               => "json.swift",
      "Tests/Fixtures/Generated/Plist/runtime-swift5/all.swift"              => "plists.swift",
      "Tests/Fixtures/Generated/Strings/structured-swift5/localizable.swift" => "strings.swift",
      "Tests/Fixtures/Generated/XCAssets/swift5/all.swift"                   => "xcassets.swift",
      "Tests/Fixtures/Generated/YAML/inline-swift5/all.swift"                => "yaml.swift",
    }
    (pkgshare/"fixtures").install fixtures
  end

  test do
    system bin/"swiftgen", "--version"

    fixtures = pkgshare/"fixtures"

    assert_equal (fixtures/"colors.swift").read.strip,
      shell_output("#{bin}/swiftgen run colors --templatePath " \
                   "#{pkgshare/"templates/colors/swift5.stencil"} #{fixtures}/colors.xml").strip,
      "swiftgen run colors failed"

    assert_equal (fixtures/"coredata.swift").read.strip,
      shell_output("#{bin}/swiftgen run coredata --templatePath " \
                   "#{pkgshare/"templates/coredata/swift5.stencil"} #{fixtures}/Model.xcdatamodeld").strip,
      "swiftgen run coredata failed"

    assert_equal (fixtures/"fonts.swift").read.strip,
      shell_output("#{bin}/swiftgen run fonts --templatePath " \
                   "#{pkgshare/"templates/fonts/swift5.stencil"} #{fixtures}/Fonts").strip,
      "swiftgen run fonts failed"

    assert_equal (fixtures/"ib-scenes.swift").read.strip,
      shell_output("#{bin}/swiftgen run ib --templatePath " \
                   "#{pkgshare/"templates/ib/scenes-swift5.stencil"} --param module=SwiftGen " \
                   "#{fixtures}/IB-iOS").strip,
      "swiftgen run ib failed"

    assert_equal (fixtures/"json.swift").read.strip,
      shell_output("#{bin}/swiftgen run json --templatePath " \
                   "#{pkgshare/"templates/json/runtime-swift5.stencil"} #{fixtures}/JSON").strip,
      "swiftgen run json failed"

    assert_equal (fixtures/"plists.swift").read.strip,
      shell_output("#{bin}/swiftgen run plist --templatePath " \
                   "#{pkgshare/"templates/plist/runtime-swift5.stencil"} #{fixtures}/Plist").strip,
      "swiftgen run plist failed"

    assert_equal (fixtures/"strings.swift").read.strip,
      shell_output("#{bin}/swiftgen run strings --templatePath " \
                   "#{pkgshare/"templates/strings/structured-swift5.stencil"} " \
                   "#{fixtures}/Localizable.strings").strip,
      "swiftgen run strings failed"

    assert_equal (fixtures/"xcassets.swift").read.strip,
      shell_output("#{bin}/swiftgen run xcassets --templatePath " \
                   "#{pkgshare/"templates/xcassets/swift5.stencil"} " \
                   "#{fixtures}/XCAssets/*.xcassets").strip,
      "swiftgen run xcassets failed"

    assert_equal (fixtures/"yaml.swift").read.strip,
      shell_output("#{bin}/swiftgen run yaml --templatePath " \
                   "#{pkgshare/"templates/yaml/inline-swift5.stencil"} #{fixtures}/YAML").strip,
      "swiftgen run yaml failed"
  end
end
