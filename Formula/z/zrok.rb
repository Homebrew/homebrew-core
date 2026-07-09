class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://github.com/openziti/zrok/releases/download/v2.0.4/source-v2.0.4.tar.gz"
  sha256 "4da44266316277b4f4b219dd22098534d273f52b08950fca1b22914aebf6f393"
  # The main license is Apache-2.0. ACKNOWLEDGEMENTS.md lists licenses for parts of code
  license all_of: ["Apache-2.0", "BSD-3-Clause", "MIT"]
  head "https://github.com/openziti/zrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3f28ef52ca95f59282e29d00c11e6db201dc2e792e194db097c52b999b938f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "760e4375381783fcd3180aa1531dda2f40f435fc93eb4c3863c73b552c393d97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c387edac9bf6497af920b5d217f744ba11fd49c23287265f4e4e3535328c4a0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "64831f44f09304a5570170dbac396716425f08b6c4b1c99ef50f0668c80f8c6c"
    sha256 cellar: :any,                 arm64_linux:   "dc0eaa34fcb11f82bbc52212ed2e16d44c9105beaed9fde2ad2e02f8674836ab"
    sha256 cellar: :any,                 x86_64_linux:  "f1b8406ba51ec78b24be8c118d121c47821876e78f8f123731febe36fa4fc890"
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
