class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://github.com/openziti/zrok/releases/download/v0.4.49/source-v0.4.49.tar.gz"
  sha256 "624d0ced7dadbb5e4b7e9b31bf0b3a3b38d028a92cbf26c29e1bad4e4fa44b3a"
  # The main license is Apache-2.0. ACKNOWLEDGEMENTS.md lists licenses for parts of code
  license all_of: ["Apache-2.0", "BSD-3-Clause", "MIT"]
  head "https://github.com/openziti/zrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db449b406dfde36a631fb522d1f12c32ce310fbc90a0a09e5f937d0379579794"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "206493664a84786bf7baa395ac9a0f47f60ec485cc3d0a8b1a283c3b32d82329"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "85ed884cfe867204b28baabef000fd0d8d5d91b55c9e27151d568ba0007c023c"
    sha256 cellar: :any_skip_relocation, sonoma:        "24c5970f9c1bee500255afbd87a81d17f6ff9ca267118c5047cad2bc053ceb3f"
    sha256 cellar: :any_skip_relocation, ventura:       "54147b91a77f9c444237cc1d77448fbb9edc01da15a269ec7185a9c5dfdcb04b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9257fac67db4bc71af02c81cbf6dc9948d95965c7de28d59e5710f971ad315e"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd buildpath/"ui" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
    end

    # Add a leading 'v' if it's not already there
    version_string = version.to_s
    version_string = "v#{version_string}" unless version_string.start_with?("v")
    

    ldflags = %W[
      -s -w
      -X github.com/openziti/zrok/build.Version=#{version_string}
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
    assert_match(version_string, version_output)
    assert_match(/[[a-f0-9]{40}]/, version_output)

    status_output = shell_output("#{bin}/zrok controller validate #{testpath}/ctrl.yml 2>&1")
    assert_match("expiration_timeout = 24h0m0s", status_output)
  end
end
