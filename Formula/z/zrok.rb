class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://github.com/openziti/zrok/releases/download/v1.1.4/source-v1.1.4.tar.gz"
  sha256 "e1fc51924e197fff908b001b9f1f52179902233390dea06e78d8fa58932c65ff"
  # The main license is Apache-2.0. ACKNOWLEDGEMENTS.md lists licenses for parts of code
  license all_of: ["Apache-2.0", "BSD-3-Clause", "MIT"]
  head "https://github.com/openziti/zrok.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d806e6f23ac938ce6bd33a0c72820092cdb61ca5b4b33fbd52e47ac066636480"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1414f9fa104dfc046ab2fcdd6bd4260f2dcfcecf5d9e5091da70fdb7fc1a9ff6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f57c2da17b9e2749abab4de725e2a86fe554188877d32b5f06789265b157fc65"
    sha256 cellar: :any_skip_relocation, sonoma:        "686536c85acc5689fc2fc74354f8aca18566dc70d81e78a9d24a68717106a0ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31936590638bbc211c0cc49f124822f4ed3b70c78ce4274b78f7921b8e87cfda"
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
