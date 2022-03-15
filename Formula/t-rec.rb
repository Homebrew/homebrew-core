class TRec < Formula
  desc "Blazingly fast terminal recorder that generates animated gif images for the web"
  homepage "https://github.com/sassman/t-rec-rs"
  url "https://github.com/sassman/t-rec-rs/archive/v0.7.3.tar.gz"
  sha256 "8da8681b6632a95d05c6461fcbf0e4b9dc93e523957c8b34aeba3fc08aeddbcc"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7671ca9d85aa8555613aa93d4cfcab0d7944c3e49f8b2d671942096fcbb58e08"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9208fb5d65d0db1a66a9520fd45b134bfbf5075a0ead077f156891c27e91b502"
    sha256 cellar: :any_skip_relocation, monterey:       "385fbf09992071d61864e4ad4d6fd60c90c541b01b9adf73ebf72a227bdb4307"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2186b3d985d26fa513bc093bdab844d9be36927540456a4dfde56e7806e5afc"
    sha256 cellar: :any_skip_relocation, catalina:       "364cf62aa59bea15b1f31eb653a7c76a66248ba557c7c7440e8510f73606eea8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b9b373e3b0e0f1831a486723bc920709629113ba4248f81ebcce0a45fe206b2"
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
      assert_equal "Error: Display parsing error", o
    end
  end
end
