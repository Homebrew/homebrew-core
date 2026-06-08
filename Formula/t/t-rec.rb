class TRec < Formula
  desc "Blazingly fast terminal recorder that generates animated gif images for the web"
  homepage "https://github.com/sassman/t-rec-rs"
  url "https://github.com/sassman/t-rec-rs/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "79ea7cbfe88e45ab913fa9963d74b9b7530cb73e39b686b0d8a692b7a9f331b8"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "157385e3762d2e024b351cffb777869ce4e7ad9113047b8cae70abfd6e572254"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df45c6c6354b2fb570c29e252d892b714fc3cef78b01ee9b2a77d099cacf3dc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11e3c4fe21f9571c79fd41638781a4d27b274df574a2b8330bbc98b1d3904c8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5276859a6a2b1beb31ecb92edc804f73f3241e7caa71fc175415b15362a02d65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e88a77bda09c3124d85389a9c1942a1af5cdf4886304dbefb770514fc30c172"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "626548f7c83623216cf151c1238264e074a2d7e6cae14256f50a59147f357db9"
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
