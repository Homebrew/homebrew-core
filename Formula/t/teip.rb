class Teip < Formula
  desc 'Masking tape to help commands "do one thing well"'
  homepage "https://github.com/greymd/teip"
  url "https://github.com/greymd/teip/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "cc735acf21f248dfabbc368835f044b99db8e1bc7fb89678681e5c68b7fee236"
  license "MIT"
  head "https://github.com/greymd/teip.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5d931a5c1f7cc0aef46988394981c63ed4bc5b88b0228661d9bda56d5979d717"
    sha256 cellar: :any,                 arm64_sequoia: "c87be3d37f592bbf60be410eeb11b60d5b89ecc4b7b13d0c1abe4c275453d792"
    sha256 cellar: :any,                 arm64_sonoma:  "7eb881d9f02d6b6d01109dacdee93bdee6f53b2be26fe698408f0c42fbead2bf"
    sha256 cellar: :any,                 sonoma:        "ad5541ab506da46cc11b52c90a723f8b9a2b2320b279efdc8060b9179c87692b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09a5c7394622b49fca8d3e015e400bf3f1880c31b3b90d2557924f10aa870278"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29745ba43c2b686f1ae71bdee0623a5e1c371f7d1c93039ce3dc619092775c6d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  uses_from_macos "llvm" => :build # for libclang

  def install
    ENV["RUSTONIG_DYNAMIC_LIBONIG"] = "1"
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"

    system "cargo", "install", *std_cargo_args(features: "oniguruma")

    man1.install "man/teip.1"
    zsh_completion.install "completion/zsh/_teip"
    fish_completion.install "completion/fish/teip.fish"
    bash_completion.install "completion/bash/teip"
  end

  test do
    require "utils/linkage"

    ENV["TEIP_HIGHLIGHT"] = "<{}>"
    assert_match "<1>23", pipe_output("#{bin}/teip -c 1", "123", 0)

    [
      Formula["oniguruma"].opt_lib/shared_library("libonig"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"teip", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
