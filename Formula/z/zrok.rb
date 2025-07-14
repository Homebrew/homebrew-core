class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://github.com/openziti/zrok/releases/download/v1.0.6/source-v1.0.6.tar.gz"
  sha256 "cce522bd8e0ec39f279e92aaba1599cd8504f9d1eebbce833c30f10047f971ca"
  # The main license is Apache-2.0. ACKNOWLEDGEMENTS.md lists licenses for parts of code
  license all_of: ["Apache-2.0", "BSD-3-Clause", "MIT"]
  head "https://github.com/openziti/zrok.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5c26032a8345ce11e510234555f588925d84a0ccfcd57eef0dac5d4531d9182"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "629d747b638f04b2c8c862646b89ada3afa7ace25229ada45a6486af3ee1328f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eaae378969ebd79eb87ebe4167b3d75afbca331639a0184605af5b2dcb9ee9e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea0f9931c4f908c8f1e65bd06275eecb19c5444a61f1469d779cfaf88d1ea5a5"
    sha256 cellar: :any_skip_relocation, ventura:       "049abb1b5e412bbbf8794d9adea317738374de6760e999a1e162bbd1a89a3edf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1778dd95654224d3e068ba35ccac4261b0b4f4a39e882f3f3f85790ec059c8d"
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
