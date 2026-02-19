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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cdb1ad3d6cfea9f868842f07320b5ac10f4ca0f7e83279fe5881e4c3857be098"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a9d0692fbc0f36bef59e74e92332e4017d871bd759c4e86b6987b53337be9f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f1c12e82a5cfaef976455a5a1eda75eb3ef9abb2f2b30aec718f1314a2c57be"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a30a0663056aba71368f90d81685d3aee8dfa491f2ec9f5e8392aabf98906a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c944f317d45e46490e441164897cbc42ca9e868bac111ce8db4ee9443cbdc13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f46ab4101a7b286375ce67383682c4de7c2fae5ce53d3056f96338452ad1b63c"
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
