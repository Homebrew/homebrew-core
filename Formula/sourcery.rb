class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/1.2.1.tar.gz"
  sha256 "a37c249c6685350a08ae18c4a223ac7370299b530a309fd10b5fb088aa71200d"
  license "MIT"
  head "https://github.com/krzysztofzablocki/Sourcery.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b51831335f1fa7ee416221ded8617a0a8ed51edef37668fc5edfc96a2dedf11b"
    sha256 cellar: :any_skip_relocation, big_sur:       "d432fb9b0b8fdfd70b5053849e7fda9e057fb3579f77b383c577dd9cec68a4e7"
    sha256 cellar: :any_skip_relocation, catalina:      "9d8d3eee64c837af95293f30f3321636978015f821f1f6703be2c4d891045e3a"
  end

  depends_on xcode: "12.0"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/sourcery"
  end

  test do
    # Regular functionality requires a non-sandboxed environment, so we can only test version/help here.
    assert_match version.to_s, shell_output("#{bin}/sourcery --version").chomp
  end
end
