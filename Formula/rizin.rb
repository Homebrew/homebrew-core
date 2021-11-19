class Rizin < Formula
  desc "UNIX-like reverse engineering framework and command-line toolset"
  homepage "https://rizin.re"
  url "https://github.com/rizinorg/rizin/releases/download/v0.3.1/rizin-src-v0.3.1.tar.xz"
  sha256 "9ae4b7f9c47be63665fd0e59375b2b10f83c37156abb044ca4d61c1f0fc88f7e"
  license "LGPL-3.0-only"
  head "https://github.com/rizinorg/rizin.git", branch: "dev"

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    assert_match "rizin #{version}", shell_output("#{bin}/rizin -v")
  end
end
