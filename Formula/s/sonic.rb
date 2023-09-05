class Sonic < Formula
  desc "Fast, lightweight & schema-less search backend"
  homepage "https://github.com/valeriansaliou/sonic"
  url "https://github.com/valeriansaliou/sonic/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "54c4bf768808ae1b5526d3c557759f5f0fd31aac453aba71638b498fc9015170"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11a23492e2ad193b664c3552fe6ba219552805787fb0eb2fbbf174aae5933cd5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a78f9e55686eaf8951e9eb4055a119872c5de7088a5f1a44c28edfa196d14bc1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f8c034a9459392dc521e60a46672f9d6c70e91c30cc5ca5b51c21913872f248"
    sha256 cellar: :any_skip_relocation, ventura:        "87956eae0267936d007753252e2297cbbb96ef129e57355a131bc5ff687a0e74"
    sha256 cellar: :any_skip_relocation, monterey:       "d123ac2daa1ef6cdebf2f4e8ab00d6fdcaca19c5367f8f66bfda3ad568bcb431"
    sha256 cellar: :any_skip_relocation, big_sur:        "532f64da105577f6ba6f90f7953370ef4d04826e7919bade075d694b6741cc31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab07e6adf7d8858270f08554aa271b84564c016e23762a45ea8d670abf926342"
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
