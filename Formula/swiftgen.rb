class Swiftgen < Formula
  desc "Swift code generator for assets, storyboards, Localizable.strings, …"
  homepage "https://github.com/SwiftGen/SwiftGen"
  url "https://github.com/SwiftGen/SwiftGen.git",
      tag:      "6.5.0",
      revision: "3b26e254b095d44f3dad06110bcb948b318898d6"
  license "MIT"
  head "https://github.com/SwiftGen/SwiftGen.git", branch: "develop"

  bottle do
    sha256 cellar: :any, big_sur:  "338165c7d38fa699a84115b5dbd5881e5f8d18b194ba9c139f05b96c5bf807f8"
    sha256 cellar: :any, catalina: "cdc09fffadaf11a05b19563d0e733d81f467b228571096bc5c32191087fd6074"
  end

  depends_on "ruby" => :build if MacOS.version <= :sierra
  depends_on xcode: ["13.0", :build]
  depends_on :macos

  def install
    # Install bundler (needed for our rake tasks)
    ENV["GEM_HOME"] = buildpath/"gem_home"
    system "gem", "install", "bundler"
    ENV.prepend_path "PATH", buildpath/"gem_home/bin"
    system "bundle", "install", "--without", "development", "release"

    # Disable linting
    ENV["NO_CODE_LINT"] = "1"

    # Install SwiftGen in `libexec` (because of our resource bundle)
    # Then create a symbolic link in `bin`
    system "bundle", "exec", "rake", "cli:install[#{libexec}]"
    bin.install_symlink "#{libexec}/swiftgen"

    # Install test fixtures
    fixtures = "Sources/TestUtils/Fixtures"
    (pkgshare/"test-fixtures").install({
      "#{fixtures}/Resources/Colors/colors.xml"                           => "colors.xml",
      "#{fixtures}/Resources/CoreData/Model.xcdatamodeld"                 => "Model.xcdatamodeld",
      "#{fixtures}/Resources/Files"                                       => "Files",
      "#{fixtures}/Resources/Fonts"                                       => "Fonts",
      "#{fixtures}/Resources/JSON"                                        => "JSON",
      "#{fixtures}/Resources/IB-iOS"                                      => "IB-iOS",
      "#{fixtures}/Resources/Plist/good"                                  => "Plist",
      "#{fixtures}/Resources/Strings/Localizable.strings"                 => "Localizable.strings",
      "#{fixtures}/Resources/XCAssets"                                    => "XCAssets",
      "#{fixtures}/Resources/YAML/good"                                   => "YAML",
      "#{fixtures}/Generated/Colors/swift5/defaults.swift"                => "colors.swift",
      "#{fixtures}/Generated/CoreData/swift5/defaults.swift"              => "coredata.swift",
      "#{fixtures}/Generated/Files/structured-swift5/defaults.swift"      => "files.swift",
      "#{fixtures}/Generated/Fonts/swift5/defaults.swift"                 => "fonts.swift",
      "#{fixtures}/Generated/IB-iOS/scenes-swift5/all.swift"              => "ib.swift",
      "#{fixtures}/Generated/JSON/runtime-swift5/all.swift"               => "json.swift",
      "#{fixtures}/Generated/Plist/runtime-swift5/all.swift"              => "plist.swift",
      "#{fixtures}/Generated/Strings/structured-swift5/localizable.swift" => "strings.swift",
      "#{fixtures}/Generated/XCAssets/swift5/all.swift"                   => "xcassets.swift",
      "#{fixtures}/Generated/YAML/inline-swift5/all.swift"                => "yaml.swift",
    })

    # Temporary fix until our build scripts support building 1 slice
    deuniversalize_machos
  end

  test do
    fixtures = pkgshare/"test-fixtures"
    test_command = lambda { |command, template, fixture, params = nil|
      assert_equal(
        (fixtures/"#{command}.swift").read.strip,
        shell_output("#{bin}/swiftgen run #{command} " \
                     "--templateName #{template} #{params} #{fixtures}/#{fixture}").strip,
        "swiftgen run #{command} failed",
      )
    }

    system bin/"swiftgen", "--version"
    test_command.call "colors", "swift5", "colors.xml"
    test_command.call "coredata", "swift5", "Model.xcdatamodeld"
    test_command.call "files", "structured-swift5", "Files"
    test_command.call "fonts", "swift5", "Fonts"
    test_command.call "ib", "scenes-swift5", "IB-iOS", "--param module=SwiftGen"
    test_command.call "json", "runtime-swift5", "JSON"
    test_command.call "plist", "runtime-swift5", "Plist"
    test_command.call "strings", "structured-swift5", "Localizable.strings"
    test_command.call "xcassets", "swift5", "XCAssets"
    test_command.call "yaml", "inline-swift5", "YAML"
  end
end
