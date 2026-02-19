class Teip < Formula
  desc 'Masking tape to help commands "do one thing well"'
  homepage "https://github.com/greymd/teip"
  url "https://github.com/greymd/teip/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "c9e45d9f5fb263a67c42907d05d8a20dd62b910175270a59decc475e66ea6031"
  license "MIT"
  head "https://github.com/greymd/teip.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "d5cf074867fb73e8e9d8553194cf8672c935c5921b969051b321021050ee841d"
    sha256 cellar: :any,                 arm64_sequoia:  "dc593ddc6816e59c32a3c28434566875dd30036937ed24fb6fbaf0b11c813f21"
    sha256 cellar: :any,                 arm64_sonoma:   "4df0b07d8bd0edaf62e6daac722039dc3dfb1f1e8340439e41c2631cb3eeec4c"
    sha256 cellar: :any,                 arm64_ventura:  "939622ea9607368b299e1eb0a3c19c01320a0399f8c01fa8502d14794fc1e983"
    sha256 cellar: :any,                 arm64_monterey: "924342e2ea29ddf0eaa9906e74c6cf03b1356d00091bf24b54788bf61136b7b4"
    sha256 cellar: :any,                 sonoma:         "3f757977cbafda79df194a8e162bd144236fc7c4bbb7ec3c3adc389130470a3a"
    sha256 cellar: :any,                 ventura:        "3c20de30934eb61457693d5c6747425220abcba516f541eaed678e5c21cf7278"
    sha256 cellar: :any,                 monterey:       "700d30d9d917de84ae8f2e517a9d424a279cc3cbad82caaa360a2b78a1133047"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e5278da10c0acf92bf08183e58fe34b4c000fa56923afb1e12f8352fb296f10f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82477350d16f0ce242352d7d6046fb2a1a2024cd9ba064219012e5c451d9b582"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  uses_from_macos "llvm" => :build # for libclang

  def install
    ENV["RUSTONIG_DYNAMIC_LIBONIG"] = "1"
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"
    system "cargo", "install", "--features", "oniguruma", *std_cargo_args
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
