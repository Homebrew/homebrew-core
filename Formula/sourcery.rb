class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code."
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/0.5.3.tar.gz"
  sha256 "ad34e2146e73ce81894ac1dd9130fb2fd12c8213789aef7c5cde9580f813c823"

  depends_on :xcode => ["8.0", :build]

  def install
    system "unset CC; swift build -c release"
    bin.install ".build/release/sourcery"
    lib.install Dir[".build/release/*.dylib"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sourcery --version").chomp
    (testpath/"Test.swift").write "enum One { }\nenum Two { }"
    (testpath/"Test.stencil").write "// Found {{ types.all.count }} Types\n// {% for type in types.all %}{{ type.name }}, {% endfor %}"
    system "#{bin}/sourcery", testpath/"Test.swift", testpath/"Test.stencil", testpath/"Generated.swift"
    assert_equal "// Generated using Sourcery 0.5.3 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// Found 2 Types
// One, Two, ", (testpath/"Generated.swift").read.strip, "sourcery generation failed"
  end
end
