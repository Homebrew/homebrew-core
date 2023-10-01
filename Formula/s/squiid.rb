class Squiid < Formula
  desc "Do advanced algebraic and RPN calculations"
  homepage "https://imaginaryinfinity.net/projects/squiid/"
  url "https://gitlab.com/ImaginaryInfinity/squiid-calculator/squiid/-/archive/1.1.0/squiid-1.1.0.tar.gz"
  sha256 "2e1ca78427c6af50945b83c50ee7bbd140dc31183c58bf38bbc983cf9e39f177"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c5138a8de15e2b06c131b4241f597e5718957a18b790f13fd81f34c5801613e6"
    sha256 cellar: :any,                 arm64_monterey: "f7752014cdd2c21c828fffb45ded4320668c0ba271f61b18a719e3f453dcdfa8"
    sha256 cellar: :any,                 ventura:        "f41f2f603113159a0bf08d8e4c7c7cf80882337aad6fdfa6b363714d597e6d7b"
    sha256 cellar: :any,                 monterey:       "dc78029d1f8a2bd1ac9c6cf22f35053e37acb1069f552026c1e35d0135837b07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f8647d2a4e017da64e1952f0a0bcae879d48a1c8d7b70543f640841655851bd"
  end

  depends_on "rust" => :build
  depends_on "nng"

  def install
    # Avoid vendoring `nng`.
    # "build-nng" is the `nng` crate's only default feature. To check:
    # https://gitlab.com/neachdainn/nng-rs/-/blob/v#{nng_crate_version}/Cargo.toml
    inreplace "Cargo.toml",
              /^nng = "(.+)"$/,
              'nng = { version = "\\1", default-features = false }'
    inreplace "squiid-engine/Cargo.toml",
              /^nng = { version = "(.+)", optional = true }$/,
              'nng = { version = "\\1", optional = true, default-features = false }'

    system "cargo", "install", *std_cargo_args
  end

  def read_stdout(stdout)
    output = ""
    loop do
      # strip off some color and style escape codes
      output += stdout.read_nonblock(1024).gsub(/\e\[[0-9;]+[A-Za-z]/, "")
    rescue IO::WaitReadable
      break if stdout.wait_readable(2).nil?

      retry
    rescue EOFError
      break
    end

    output
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    require "pty"

    PTY.spawn("#{bin}/squiid") do |r, w, pid|
      sleep 1 # wait for squiid to start

      w.write "(10 - 2) * (3 + 5) / 4\r"
      assert_match "(10-2)*(3+5)/4=16", read_stdout(r)
      w.write "quit\r"

      # for some reason the test hangs on macOS until stdout is read again
      read_stdout(r) unless OS.linux?
      Process.wait(pid)
    rescue PTY::ChildExited
      # app exited
    end

    assert check_binary_linkage(bin/"squiid", Formula["nng"].opt_lib/shared_library("libnng")),
      "No linkage with libnng! Cargo is likely using a vendored version."
  end
end
