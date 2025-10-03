class Swiftgen < Formula
  desc "Swift code generator for assets, storyboards, Localizable.strings, etc."
  homepage "https://github.com/SwiftGen/SwiftGen"
  url "https://github.com/SwiftGen/SwiftGen/archive/refs/tags/6.6.3.tar.gz"
  sha256 "f529be194f0ffcc85a76a6770fe3578b49e7e56ba872ce1e3aaba75982b09d32"
  license "MIT"
  head "https://github.com/SwiftGen/SwiftGen.git", branch: "stable"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "001dc72c675528810114e961f7a9d743504ab3fd58c50e5be6363fcb76c91382"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "49cf0b56d500cf87acc05ca32f5007b750469c865253bd6b070dffcd309d8065"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc57fa733294a7d4d27714cd3eb954f2f8de1231cc0f991e6c043e2528a25311"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab20119231242e90668b5129c07d7114abaa9e7af647fe3f9fa511999f0b6548"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6efea7084dd6e75732483d417abf476da8f41a0513059f0133c03b1711e92ac3"
    sha256 cellar: :any_skip_relocation, sonoma:         "20b600909007b301f5daae7954e1587b4275a2818671ab96ae584139fb6d184f"
    sha256 cellar: :any_skip_relocation, ventura:        "61b7e10cb59fa9a8a84b55c7945cdcc3d854b40baaca057e658e528aac091f4b"
    sha256 cellar: :any_skip_relocation, monterey:       "535fd043b81c91f3c8953cfd7d13721d12d205215f19b10f6549230847cbe3f1"
  end

  depends_on xcode: ["13.3", :build]
  depends_on :macos

  uses_from_macos "ruby" => :build

  def install
    # Install bundler (needed for our rake tasks)
    ENV["GEM_HOME"] = buildpath/"gem_home"

    # we use the macOS ruby (2.6.10p210 (2022-04-12 revision 67958)) this is the last supported bundler version
    system "gem", "install", "bundler", "-v 2.4.22"

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
    resource("testdata") do
      url "https://github.com/SwiftGen/SwiftGen/archive/refs/tags/6.6.3.tar.gz"
      sha256 "f529be194f0ffcc85a76a6770fe3578b49e7e56ba872ce1e3aaba75982b09d32"
    end

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
