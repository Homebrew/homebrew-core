class TRec < Formula
  desc "Blazingly fast terminal recorder that generates animated gif images for the web"
  homepage "https://github.com/sassman/t-rec-rs"
  url "https://github.com/sassman/t-rec-rs/archive/refs/tags/v0.7.9.tar.gz"
  sha256 "1744fb7743209ea153a729f89e8e7f2f03bd61247488fbeea31abbe234087cd7"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31e705c01ca086aeb97ea2ab92f97cdc982e8a2c003fa1262352c282c9e184f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f6104c42e6d8dc1dd9c33f8d9a62b2c331054878b475991b1ed32ad72012cc6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3697e02ec5dfa92fc7168ffac442b767fc4d3a2a6ec994e8ca90f22720e52e96"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ee2792601edc77380d0749e1e7605cd8f2607311b1225ecae60a7314b3bc68b"
    sha256 cellar: :any_skip_relocation, ventura:       "20f8a41fa02ef8d34c2525dd831f67be5e13a87df27ef3ff9289ca69272e44cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7f070666a185ffc61a81f8e9d5c9bd128b3fcb12e53d01c6906df0d91d92c10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62fa013bdcdb71ede6a588656dad31e8af3e6184d6ced54c6218959ab79899fe"
  end

  depends_on "rust" => :build
  depends_on "imagemagick"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    o = shell_output("WINDOWID=999999 #{bin}/t-rec 2>&1", 1).strip
    if OS.mac?
      assert_equal "Error: Cannot grab screenshot from CGDisplay of window id 999999", o
    else
      assert_equal "Error: $DISPLAY variable not set and no value was provided explicitly", o
    end
  end
end
