class Xfr < Formula
  desc "Modern network bandwidth testing with TUI"
  homepage "https://github.com/lance0/xfr"
  url "https://github.com/lance0/xfr/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "fc32357dd5f55d88a6b453b829ff2266efca53871487846c3eb8ae14650a017e"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/lance0/xfr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "93c873f1da7c3ff2ccd2df5b1d5696df0bc2ed19d2fde4dd5bb03ed7f2d362c0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "91f853c6c3095c0ac29d404ad0d15fb34c68edcd191d54b285d4f799f97622ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ab3a9ba6830bd1494f940fa14e9234dd89709f621d70925dc06f8e5181afc191"
    sha256 cellar: :any,                 arm64_linux:       "c8d44bda504be3549d60fe3d48b9d775b4401f03dc817effe377de27d12bd60a"
    sha256 cellar: :any,                 x86_64_linux:      "b6505187a67db005b035e52a6d9b83554cc9a3f763c83afa8bc3e39bfdf66258"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"xfr", shell_parameter_format: "--completions=")
    man1.install "docs/xfr.1"
  end

  test do
    ENV["XFR_NO_UPDATE_CHECK"] = "1"
    port = free_port
    pid = spawn bin/"xfr", "serve", "--port", port.to_s, "--no-mdns"
    sleep 1
    output = shell_output("#{bin}/xfr 127.0.0.1 --port #{port} --time 1sec --json")
    assert_operator JSON.parse(output)["bytes_total"], :>, 0
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
