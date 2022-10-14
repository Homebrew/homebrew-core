class Xwin < Formula
  desc "Microsoft CRT and Windows SDK headers and libraries loader"
  homepage "https://github.com/Jake-Shadle/xwin"
  url "https://github.com/Jake-Shadle/xwin/archive/refs/tags/0.2.9.tar.gz"
  sha256 "e53bf34952623f6a306e3ee1a73ac63108e349b76a7e25054230baefdb9f7606"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc724e3c680a794289365a75bf0a7a0ed3f4f739edbed076f332cbee0a3b846b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61bbd9b75d4a85a88c0912f9b5e9d517e5c2f8e45cd16b0229eff958bd61f24b"
    sha256 cellar: :any_skip_relocation, monterey:       "746c343cdf21d2bb37f756d180e03a1a87da63cbfaa7586fc0041bd23d9e06ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1e80406dabe4746528e1743cf61d8f72572de9d355d09cb41ff1aa7fa6adbee"
    sha256 cellar: :any_skip_relocation, catalina:       "238764df75009a2eabe9a3b1c9ed897a4de0704caf7322073cc4c6404dbf17b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5dd44689786c3bcc223af6a4bcdce9a093cbb752dce28c11b494f32c47af529"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"xwin", "--accept-license", "splat", "--disable-symlinks"
    assert_predicate testpath/".xwin-cache/splat", :exist?
  end
end
