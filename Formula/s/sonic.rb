class Sonic < Formula
  desc "Fast, lightweight & schema-less search backend"
  homepage "https://github.com/valeriansaliou/sonic"
  url "https://github.com/valeriansaliou/sonic/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "ae2c584d0c4d73d16e2a98c9a7b7d0a71ff72ab7db29210854c730d30d739942"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3c75c06c21554ad85957c23ba115672de7c4bcdbc334d0281c889434feb1f3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c980840c9ba2a3d159c622417c26333b995c608ab1c7116f9f1135cdc1d4096"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3fcf6038d479fb20eead6df10213bade4b43a02f2f8892160fd7a090a604e07f"
    sha256 cellar: :any_skip_relocation, ventura:        "e049843eedc189512c1baa1923b820f326c87fee5056d352951ecb5deece8c8f"
    sha256 cellar: :any_skip_relocation, monterey:       "6de1aaf83f17590f20c0759dc83903acdce24cc3bd651831906409bebd471d97"
    sha256 cellar: :any_skip_relocation, big_sur:        "a449ef361f6d39ed236810c94bfab3717c6496cbb4987b27b19372b1be6bc639"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2eee3f6c1232c6eaea8eb38994b733f75ee579daf0226fdfa638580647d794bf"
  end

  # Use `llvm@15` to work around build failure with Clang 16 described in
  # https://github.com/rust-lang/rust-bindgen/issues/2312.
  # TODO: Switch back to `uses_from_macos "llvm" => :build` when `bindgen` is
  # updated to 0.62.0 or newer. There is a check in the `install` method.
  depends_on "llvm@15" => :build
  depends_on "rust" => :build

  uses_from_macos "netcat" => :test

  def install
    bindgen_version = Version.new(
      (buildpath/"Cargo.lock").read
                              .match(/name = "bindgen"\nversion = "(.*)"/)[1],
    )
    if bindgen_version >= "0.62.0"
      odie "`bindgen` crate is updated to 0.62.0 or newer! Please remove " \
           'this check and try switching to `uses_from_macos "llvm" => :build`.'
    end

    system "cargo", "install", *std_cargo_args
    inreplace "config.cfg", "./", var/"sonic/"
    etc.install "config.cfg" => "sonic.cfg"
  end

  service do
    run [opt_bin/"sonic", "-c", etc/"sonic.cfg"]
    keep_alive true
    working_dir var
    log_path var/"log/sonic.log"
    error_log_path var/"log/sonic.log"
  end

  test do
    port = free_port

    cp etc/"sonic.cfg", testpath/"config.cfg"
    inreplace "config.cfg", "[::1]:1491", "0.0.0.0:#{port}"
    inreplace "config.cfg", "#{var}/sonic", "."

    fork { exec bin/"sonic" }
    sleep 10
    system "nc", "-z", "localhost", port
  end
end
