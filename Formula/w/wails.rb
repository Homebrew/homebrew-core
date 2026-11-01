class Wails < Formula
  desc "Create beautiful applications using Go"
  homepage "https://wails.io"
  url "https://github.com/wailsapp/wails/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "d98866b5f7a2e2378a3cc5ca76422bcef27d669bbe1dd5792a35db2589262e1f"
  license "MIT"
  head "https://github.com/wailsapp/wails.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(:?\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "462953e893404a7cb4cbca1432397f25f19cfc181055c025795fb90d81a21a05"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a307231ed629959d6379cb5bfcdda5996d798ea8741d82bc33e0f22ac6572698"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "416bcde673338f92762087174f58ffa0c5a73398b4810acc96543091b4db64a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0b5f6b600b4388a7a4e93062b6a424ffd471bbe6b2f673d9dbfd2bf2c1c43080"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ce3ba46f9d50b24a182e6db594a1cd9ebce398e7956f40de3ae01a6d48149b35"
  end

  depends_on "go"

  # Test scaffolds a project, which downloads Go modules
  allow_network_access! :test

  def fetch
    cd "v3" do
      system "go", "mod", "download"
    end
  end

  def install
    # Disable modules that require GTK
    ENV["CGO_ENABLED"] = "0" if OS.linux?
    cd "v3" do
      system "go", "build", *std_go_args, "./cmd/wails3"
    end
  end

  test do
    ENV["NO_COLOR"] = "1"

    output = shell_output("#{bin}/wails init -n brewtest 2>&1")
    assert_match(/Name\s+brewtest/, output)
    assert_match(/Framework\s+Vanilla/, output)

    assert_path_exists testpath/"brewtest/go.mod"
    assert_match 'APP_NAME: "brewtest"', (testpath/"brewtest/Taskfile.yml").read

    assert_match version.to_s, shell_output("#{bin}/wails version 2>&1")
  end
end
