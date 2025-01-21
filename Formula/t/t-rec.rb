class TRec < Formula
  desc "Blazingly fast terminal recorder that generates animated gif images for the web"
  homepage "https://github.com/sassman/t-rec-rs"
  url "https://github.com/sassman/t-rec-rs/archive/refs/tags/v0.7.8.tar.gz"
  sha256 "681beb0ed7559efb85a6bbb34fdcec7329c16a71ae44851ea20e1b18e8142aae"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "991072eed6dabd956479718e01ab933fcd5bfbc139ee6e9c52ab097cd3e26b3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f60587ab3f64cc1101574fe36a554de16d22b9b41d9fae897efb5593eab8ff52"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1a101b8bb37a5317fd3650ce6809e282f73f2d5b4fb0b4791914b3c334b8fee"
    sha256 cellar: :any_skip_relocation, sonoma:        "69e4fdc909fb6a45cad285448044deea17ff592d72e52364ffb5c41305279306"
    sha256 cellar: :any_skip_relocation, ventura:       "0be6a2634425cccfc5989a6cee087aa45f1e4bf2e6c167cd715df3f04530c647"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ac50c1f38d896c6cc6a48c0395b330647bf35e795c16c7eccadba00b731395e"
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
