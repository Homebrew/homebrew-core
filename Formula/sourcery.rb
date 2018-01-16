class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/0.10.1.tar.gz"
  sha256 "fa27c1aa820b1df6cfbaac5bfe07985d4202583bbc44f9b4ac6ab474e02f70e6"
  head "https://github.com/krzysztofzablocki/Sourcery.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "03a8adf163c40a29fa4d00acad302f57f8d901a02645b1323abf1d165e1c7679" => :high_sierra
    sha256 "34f0240218d5e47bb046d3e5bc6c06dd4a16e8ac572c0dfdadd41a2cb0625512" => :sierra
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
