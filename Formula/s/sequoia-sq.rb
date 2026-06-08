class SequoiaSq < Formula
  desc "Sequoia-PGP command-line tool"
  homepage "https://sequoia-pgp.org"
  url "https://gitlab.com/sequoia-pgp/sequoia-sq/-/archive/v1.3.1/sequoia-sq-v1.3.1.tar.gz"
  sha256 "9f112096f413e195ec737c81abb5649604f16e1f6dbe64a8accc5bb3ad39e239"
  license "LGPL-2.0-or-later"
  head "https://gitlab.com/sequoia-pgp/sequoia-sq.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "19aea334d358be2cc1ceef010acf929d5878e06a049c7c5fc0857e11811c770f"
    sha256 cellar: :any,                 arm64_sequoia: "a1a5edfd41e376367742c538e096a482a3ec74410a5b86e5687d774ea91d8a3e"
    sha256 cellar: :any,                 arm64_sonoma:  "824517c9fb8af79ed92d680d516afaf6359cb02153cfe453e6dd841b0d2bb2df"
    sha256 cellar: :any,                 sonoma:        "31860aa77c849ceb1e9f700b43ab293b6308d45627fb0fdf0a7e9b23b5aae893"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09c647e848febcff9a447a124ebe3701ce1b7c340f08bf4b7e1f3f2386659a9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15bd1a4c8b63463a27f65cac2e61af18bedceacb8e0a08c776caa8f1bb3b40d5"
  end

  depends_on "capnp" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "openssl@3"

  uses_from_macos "llvm" => :build
  uses_from_macos "bzip2"
  uses_from_macos "sqlite"

  conflicts_with "sq", "squirrel-lang", because: "both install `sq` binaries"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["ASSET_OUT_DIR"] = buildpath

    system "cargo", "install", "--no-default-features", *std_cargo_args(features: "crypto-openssl")
    man1.install Dir["man-pages/*.1"]

    bash_completion.install "shell-completions/sq.bash" => "sq"
    zsh_completion.install "shell-completions/_sq"
    fish_completion.install "shell-completions/sq.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sq version 2>&1")

    output = pipe_output("#{bin}/sq packet armor", test_fixtures("test.gif").read, 0)
    assert_match "R0lGODdhAQABAPAAAAAAAAAAACwAAAAAAQABAAACAkQBADs=", output
  end
end
