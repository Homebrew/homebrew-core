class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code."
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/0.8.0.tar.gz"
  sha256 "00efd7cc7822a77dd7d103ff15d0b9d976b75dce0b41fa2ece813dd9ce6fa033"
  head "https://github.com/krzysztofzablocki/Sourcery.git"

  bottle do
    cellar :any
    sha256 "742d933c599d255699efa4a10e4f58f63c784f08db681c0eb0c3d28056601d33" => :sierra
  end

  depends_on :xcode => ["6.0", :run]
  depends_on :xcode => ["8.3", :build]

  def install
    ENV.delete("CC")
    ENV["SDKROOT"] = MacOS.sdk_path
    system "swift", "build", "-c", "release", "-Xswiftc", "-static-stdlib"
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
