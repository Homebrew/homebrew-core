class Squiid < Formula
  desc "Do advanced algebraic and RPN calculations"
  homepage "https://imaginaryinfinity.net/projects/squiid/"
  url "https://gitlab.com/ImaginaryInfinity/squiid-calculator/squiid/-/archive/1.1.1/squiid-1.1.1.tar.gz"
  sha256 "2534e01d7b7a5b1793bb3cb5f6ebe4a404a5d8e131f87595ff8afb98a4838367"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a443b05fa1907a2fcb23ec18d1aed61fd859b1bde705041a1007ec8130d2f859"
    sha256 cellar: :any,                 arm64_ventura:  "ca132ff60afa5d3a66c21c562c7fe919dbdef8b029d19e44a170d149b03b07df"
    sha256 cellar: :any,                 arm64_monterey: "0e1c890d209bdc4820024458acc920e06fcf774ac15581da13d872b78bb37cda"
    sha256 cellar: :any,                 sonoma:         "a9f4a0604aa3a7fc6d8c2c43c11dede38493b08f338f6e87a9da9e25f0da4ccb"
    sha256 cellar: :any,                 ventura:        "b05ad841186178cab1c3389495dfe7178830cb45a2c9a1b7a6a5eb09b69bb5a2"
    sha256 cellar: :any,                 monterey:       "7c7685b1e78fa9f9b5539dbc0d875d89b82f3339e2ffb9decacd8f534d28446e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f12ed29e01e471cb09f66eb454b02ed1d482789558addcb4aa18f43cdb9f5ea3"
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
