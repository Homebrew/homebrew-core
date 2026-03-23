class Serie < Formula
  desc "Rich git commit graph in your terminal"
  homepage "https://github.com/lusingander/serie"
  url "https://github.com/lusingander/serie/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "6a8961a96140c1120aa323eab651d25b613910828567e941161adca219875347"
  license "MIT"
  head "https://github.com/lusingander/serie.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa6841a55a904ee18493fc5324b27cf02d413add096e8d2156738b29a5ae5254"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df0849548783514d1477d6a8bd814bf69f62aacb218399e8d1ca353cf6696f83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "822cd999c9e4c9511eb3dba5a7c10b109848ac119139135ff7b04d9317a8eb68"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3a94f478ee73d2b5ce1afe0620586f2d02235338a3a24d9a865bf4d3f9212ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9728e88b60c862db51e9fe12fb55b214cdb0067ec0dca62887099d5be7e3ffa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "459789d5b8461a3ff704c514163bd8f452f22aaa6fafaf7a4188cf55869b141d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/serie --version")

    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "Initial commit"

    begin
      output_log = testpath/"output.log"
      if OS.mac?
        pid = spawn bin/"serie", [:out, :err] => output_log.to_s
      else
        require "pty"
        r, _w, pid = PTY.spawn("#{bin}/serie > #{output_log}")
        r.winsize = [80, 130]
      end
      sleep 1
      sleep 2 if OS.mac? && Hardware::CPU.intel?
      assert_match "Initial commit", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
