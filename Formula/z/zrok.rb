class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://github.com/openziti/zrok/releases/download/v2.0.10/source-v2.0.10.tar.gz"
  sha256 "d0424960543227c2323106a7cd464d8a262b68dd233e4117a998f87463d18d81"
  # The main license is Apache-2.0. ACKNOWLEDGEMENTS.md lists licenses for parts of code
  license all_of: ["Apache-2.0", "BSD-3-Clause", "MIT"]
  head "https://github.com/openziti/zrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "11e39723fb73687791aeab4525fbeceb2c942193315daf5b2424aa9c3bca00ec"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2dec3026cf9e41dd16104ac0eb6c2da6a63d488e642a4273e0ac56cb93c9f452"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "699dc6961ee93dffc1f96bd694bd90dbb40d196d41c0f7608d4f60febe2ff285"
    sha256 cellar: :any,                 arm64_linux:       "2ce9f711c77cb262c42adec6906ba9ab751e3667e8829bc6c4daea5f6a6fc164"
    sha256 cellar: :any,                 x86_64_linux:      "18e33ffbacc21eeb57fe36fdb5afb8f6335b227bccec14679bf71af1abb20264"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  deny_network_access!

  def ui_dirs = ["ui", "agent/agentUi"]

  def fetch
    ui_dirs.each do |ui_dir|
      cd ui_dir do
        system "npm", "install", *std_npm_args(prefix: false)
      end
    end
    system "go", "mod", "download"
  end

  def install
    ui_dirs.each do |ui_dir|
      cd ui_dir do
        system "npm", "run", "build"
      end
    end

    # Workaround to avoid patchelf corruption when cgo is required (for go-sqlite3)
    if OS.linux? && Hardware::CPU.arm64?
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    ldflags = %W[
      -X github.com/openziti/zrok/v2/build.Version=v#{version}
      -X github.com/openziti/zrok/v2/build.Hash=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/zrok2"

    generate_completions_from_executable(bin/"zrok", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"ctrl.yml").write <<~YAML
      v: 4
      maintenance:
        registration:
          expiration_timeout:           24h
          check_frequency:              1h
          batch_limit:                  500
        reset_password:
          expiration_timeout:           15m
          check_frequency:              15m
          batch_limit:                  500
    YAML

    version_output = shell_output("#{bin}/zrok version")
    assert_match(/\bv#{version}\b/, version_output)
    assert_match(/[[a-f0-9]{40}]/, version_output)

    status_output = shell_output("#{bin}/zrok controller validate #{testpath}/ctrl.yml 2>&1")
    assert_match(/expiration_timeout\s+:\s+24h0m0s/, status_output)
  end
end
