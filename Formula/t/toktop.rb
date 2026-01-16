class Toktop < Formula
  desc "LLM usage monitor in terminal"
  homepage "https://github.com/htin1/toktop"
  url "https://github.com/htin1/toktop/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "9e01566757971e7cf42dd881ea9e8a8a53bbda4dade210a3c80df71638418ee4"
  license "MIT"
  head "https://github.com/htin1/toktop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81b60c4db8d8e71b854343dce34ad15cb3a4d218c7c820ec7a42e6752d3524a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea7d255624a76f6332978c3019ad0d25699ba88bbff0ed84102b958ee859beb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96af29240deb71058d1e3b55d213a5dbca0de7b5100ef64870c1ae7b30dbecd6"
    sha256 cellar: :any_skip_relocation, sonoma:        "a85dbdc95d247db1c715d22f3ed796e5f8b9f766f6675eec437061f9ee1ce55a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c79110b2d6f8b06be709551489dc9560e49c12f488e55807b96445b2ff0fd03a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ea37e348919685e3147df282f19caf6a07f3b6d13f8a1e7142a8e60adacebdf"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["OPENAI_ADMIN_KEY"] = "test"
    ENV["ANTHROPIC_ADMIN_KEY"] = "test"
    assert_match "OpenAI", if OS.mac?
      pipe_output("#{bin}/toktop 2>&1", "\e", 1)
    else
      require "pty"
      r, w, pid = PTY.spawn("#{bin}/toktop 2>&1")
      r.winsize = [80, 43]
      w.write "q\nq"
      Process.wait(pid)
      r.read_nonblock(4096)
    end
  end
end
