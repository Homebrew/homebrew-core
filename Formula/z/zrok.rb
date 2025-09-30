class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://github.com/openziti/zrok/releases/download/v1.1.5/source-v1.1.5.tar.gz"
  sha256 "c36324ff2b242d91e1f6abf8e45e311c7d63357aecc5c30012337ac695dedd81"
  # The main license is Apache-2.0. ACKNOWLEDGEMENTS.md lists licenses for parts of code
  license all_of: ["Apache-2.0", "BSD-3-Clause", "MIT"]
  head "https://github.com/openziti/zrok.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ecd26f91b7617c760b2600ff432e08b4a89304abe1b1d2098fe0bb09cbf0486"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bbbfd8991fde574c793e97bb560ca34888ea9dbdb433e229bc8764274dc4fc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "616a3e643095247447f6dc687f655e68f2707687a6c7b4a12cf961baf82feed8"
    sha256 cellar: :any_skip_relocation, sonoma:        "913b96cf4da36ad10b13c73bea0705ec42bb85c16677090928948e88bb0c11c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "befc616d99c782f9aaaaa3386aa8a07573ab0fa2abbc4e02d37da53ef2bd414c"
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
