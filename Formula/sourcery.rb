class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/0.10.0.tar.gz"
  sha256 "730f56b7f93a1ec3f4c197780f8668e5d604d618e85568c134a78265aade60b2"
  head "https://github.com/krzysztofzablocki/Sourcery.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f85a4ba19bf64fee74a4a5ca32b6fec0c06e0a489f91ebe65bd79bbe5c2134d4" => :high_sierra
    sha256 "faa08e1d1174909d70aa739a96539e2aef6209a4430d518220b4d46f158275f1" => :sierra
  end

  depends_on :xcode => ["6.0", :run]
  depends_on :xcode => ["8.3", :build]

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "-Xswiftc",
           "-static-stdlib"
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
