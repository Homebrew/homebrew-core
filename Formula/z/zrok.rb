class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://github.com/openziti/zrok/releases/download/v1.1.7/source-v1.1.7.tar.gz"
  sha256 "c49843eb5b9e7686a2717edec543a542560f8270774240007ac48ed4810cf44c"
  # The main license is Apache-2.0. ACKNOWLEDGEMENTS.md lists licenses for parts of code
  license all_of: ["Apache-2.0", "BSD-3-Clause", "MIT"]
  head "https://github.com/openziti/zrok.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e38c2f44ea272342f5881b5e77c63ab1576930d97e96b38feb2356a2999ebffd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9411b3222f0d54b41143972bd1cbd42d4273e14b9587509c62ada0767ecacd13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e9128c23e7a6d4c49344e2c32722bdf4a27edfd20d2f0ff644cb32a0acf43ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "735862d36906e96f09c216d2735b3433749ed8fcf97038ea8097208cae158f46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e2c10f15afe76672897b25ef8e04660fa22f45ab2a0d61867c0bce0f18a21b9"
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
