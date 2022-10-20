class Swiftgen < Formula
  desc "Swift code generator for assets, storyboards, Localizable.strings, …"
  homepage "https://github.com/SwiftGen/SwiftGen"
  url "https://github.com/SwiftGen/SwiftGen/archive/6.6.2.tar.gz"
  sha256 "73b73e32ce22554c9db44c8edf0fa0ada33b413c73e8f991eebfaac4073df3de"
  license "MIT"
  head "https://github.com/SwiftGen/SwiftGen.git", branch: "stable"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22d90e985b8a6ab49311800eeb7ab721f4872bc85a60b44b7ad57954453569c8"
    sha256 cellar: :any_skip_relocation, monterey:       "3c158aecb7ced0c489ef11f6a4c15a9d1449a40ad554388a0310116f510ec316"
  end

  depends_on xcode: ["13.3", :build]
  depends_on :macos

  uses_from_macos "ruby" => :build, since: :high_sierra

  resource("testdata") do
    url "https://github.com/SwiftGen/SwiftGen/archive/6.6.2.tar.gz"
    sha256 "73b73e32ce22554c9db44c8edf0fa0ada33b413c73e8f991eebfaac4073df3de"
  end

  def install
    # Install bundler (needed for our rake tasks)
    ENV["GEM_HOME"] = buildpath/"gem_home"
    system "gem", "install", "bundler"
    ENV.prepend_path "PATH", buildpath/"gem_home/bin"
    system "bundle", "install", "--without", "development", "release"

    # Disable linting
    ENV["NO_CODE_LINT"] = "1"

    # Install SwiftGen in `libexec` (because of our resource bundle)
    # Then create a script to invoke it
    system "bundle", "exec", "rake", "cli:install[#{libexec}]"
    bin.write_exec_script "#{libexec}/swiftgen"
  end

  test do
    # prepare test data
    resource("testdata").stage testpath
    fixtures = testpath/"Sources/TestUtils/Fixtures"
    test_command = lambda { |command, template, resource_group, generated, fixture, params = nil|
      assert_equal(
        (fixtures/"Generated/#{resource_group}/#{template}/#{generated}").read.strip,
        shell_output("#{bin}/swiftgen run #{command} " \
                     "--templateName #{template} #{params} #{fixtures}/Resources/#{resource_group}/#{fixture}").strip,
        "swiftgen run #{command} failed",
      )
    }

    system bin/"swiftgen", "--version"

    #                 command     template             rsrc_group  generated            fixture & params
    test_command.call "colors",   "swift5",            "Colors",   "defaults.swift",    "colors.xml"
    test_command.call "coredata", "swift5",            "CoreData", "defaults.swift",    "Model.xcdatamodeld"
    test_command.call "files",    "structured-swift5", "Files",    "defaults.swift",    ""
    test_command.call "fonts",    "swift5",            "Fonts",    "defaults.swift",    ""
    test_command.call "ib",       "scenes-swift5",     "IB-iOS",   "all.swift",         "", "--param module=SwiftGen"
    test_command.call "json",     "runtime-swift5",    "JSON",     "all.swift",         ""
    test_command.call "plist",    "runtime-swift5",    "Plist",    "all.swift",         "good"
    test_command.call "strings",  "structured-swift5", "Strings",  "localizable.swift", "Localizable.strings"
    test_command.call "xcassets", "swift5",            "XCAssets", "all.swift",         ""
    test_command.call "yaml",     "inline-swift5",     "YAML",     "all.swift",         "good"
  end
end
