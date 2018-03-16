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
    assert_match version.to_s, shell_output("#{bin}/sourcery --version").chomp
  end
end
