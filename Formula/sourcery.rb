class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code."
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/0.5.8.tar.gz"
  sha256 "71e0f99c28e2666b3e7f2c6c7f84bae6339930a34609cef716d3e14eac6f4d7b"

  bottle do
    cellar :any
    sha256 "bc5cb0b60891b8d9b735242fcdf9a2497abeeb698f69396ffb51322e16dd0541" => :sierra
    sha256 "742cb297bb3b693b4653318867c6d3fe5eebd708a8039a674726a8a39dde1033" => :el_capitan
  end

  depends_on :xcode => ["8.0", :build]

  def install
    ENV.delete("CC")
    ENV["SDKROOT"] = MacOS.sdk_path
    system "swift", "build", "-c", "release"
    bin.install ".build/release/sourcery"
    lib.install Dir[".build/release/*.dylib"]
  end

  test do
    # Tests are temporarily disabled because of sandbox issues,
    # as Sourcery tries to write to ~/Library/Caches/Sourcery
    # See https://github.com/krzysztofzablocki/Sourcery/pull/133
    #
    # Remove this test once the PR has been merged and been tagged with a release
    assert_match version.to_s, shell_output("#{bin}/sourcery --version").chomp

    # Re-enable these tests when the issue has been closed
    #
    # (testpath/"Test.swift").write <<-TEST_SWIFT
    # enum One { }
    # enum Two { }
    # TEST_SWIFT
    #
    # (testpath/"Test.stencil").write <<-TEST_STENCIL
    # // Found {{ types.all.count }} Types
    # // {% for type in types.all %}{{ type.name }}, {% endfor %}
    # TEST_STENCIL

    # system "#{bin}/sourcery", testpath/"Test.swift", testpath/"Test.stencil", testpath/"Generated.swift"

    # expected = <<-GENERATED_SWIFT
    # // Generated using Sourcery 0.5.3 - https://github.com/krzysztofzablocki/Sourcery
    # // DO NOT EDIT
    #
    #
    # // Found 2 Types
    # // One, Two,
    # GENERATED_SWIFT
    # assert_match expected, (testpath/"Generated.swift").read, "sourcery generation failed"
  end
end
