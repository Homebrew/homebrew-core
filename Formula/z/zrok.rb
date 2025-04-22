class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://github.com/openziti/zrok/releases/download/v1.0.2/source-v1.0.2.tar.gz"
  sha256 "5421cad74f819e231e1f63749fa4693c0e2903a067840e884a88f7c852f720fe"
  # The main license is Apache-2.0. ACKNOWLEDGEMENTS.md lists licenses for parts of code
  license all_of: ["Apache-2.0", "BSD-3-Clause", "MIT"]
  head "https://github.com/openziti/zrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8109ef5b4ab0e83ef5b505830ccbb9f9c03d1c6bd4f56760a0e5179e50ecff1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd1e8d4f576595de43dd2af72ae07052f4e50b8ce575aacbf0c896bec128eac8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "09a693d91215f1fb976674182eab12d7f66cd2fc0465751ecd07e1342a01ac64"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6c083b0f8f54057002d496ef2dc05acbc62aac956bd91e628af71d8e5a1b6de"
    sha256 cellar: :any_skip_relocation, ventura:       "b71feca38289edc1ea1a6540d80e205ba1cdcc003f18081b7278d4164e5c698a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4894de483ef625f8b34672181ed3ff4b53b32f2fecbdb3fb1392679874ffc9a6"
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
