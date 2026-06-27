class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://github.com/openziti/zrok/releases/download/v1.1.11/source-v1.1.11.tar.gz"
  sha256 "374da7b0cea19c2fa284d8dec5145e3b2374976d23d0f432e1dbcf07c0285073"
  # The main license is Apache-2.0. ACKNOWLEDGEMENTS.md lists licenses for parts of code
  license all_of: ["Apache-2.0", "BSD-3-Clause", "MIT"]
  head "https://github.com/openziti/zrok.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd819d5a0c3a7406c81099a79ad510e8a0013b9a66ac1a1032ef3ee9aabbce45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21df7b8670a168d811315204fe6ca38021b94ea1c779f9bcd60f4cca56afbd3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23470eebb64e12f7cef28b961cfd2b50e46c7ea4c58e60bce2dcba9a9ff7e009"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f039ab8c173242c8ce00b9aa1308915a7687f7c09f22436f19297623a269f49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e39cbef58bc7868120538038e792540ad4f321e6f24e5513719305f2505c653"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b49960027c348467c85223c701f1d510581fb191c6590007e62f4e53fa6d89e"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    ["ui", "agent/agentUi"].each do |ui_dir|
      cd "#{buildpath}/#{ui_dir}" do
        system "npm", "install", *std_npm_args(prefix: false)
        system "npm", "run", "build"
      end
    end

    # Workaround to avoid patchelf corruption when cgo is required (for go-sqlite3)
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    ldflags = %W[
      -s -w
      -X github.com/openziti/zrok/build.Version=v#{version}
      -X github.com/openziti/zrok/build.Hash=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/zrok"

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
    assert_match("expiration_timeout = 24h0m0s", status_output)
  end
end
