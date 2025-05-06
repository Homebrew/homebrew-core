class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://github.com/openziti/zrok/releases/download/v1.0.4/source-v1.0.4.tar.gz"
  sha256 "995d5213b85683732360c9bb7633c8a467e80bc9e4b6b3265bbf4507525acbb9"
  # The main license is Apache-2.0. ACKNOWLEDGEMENTS.md lists licenses for parts of code
  license all_of: ["Apache-2.0", "BSD-3-Clause", "MIT"]
  head "https://github.com/openziti/zrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "facbea9b67d3253b62a0d26fbae4fd8b34b4bfe475629ae422e52171838047c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14e23d6ba9863c6e1b43a4112e82ef49df8add2011335ad6f114a7f7a0e7d745"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "250a931684772109107a0e0163758edd50c1fd59d41a9812ee3e3a0b4b896379"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca927933798ac8dbf906990ea3a9bd5eeaf70f37c39bfa91fd6334527afc68a0"
    sha256 cellar: :any_skip_relocation, ventura:       "ab95e0bbb2198ba4b3b1d2fe46a96cee70dc9eb9cfe8e1db2f737780fdc982bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce187843ffa80bf491a5223bfe9d05fe5f73a3adfa735e85b14e68f745e80d93"
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
