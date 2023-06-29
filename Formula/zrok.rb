require "language/node"

class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://github.com/openziti/zrok/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "2543bffb999428abf20ce0f2dec3d63e32ffb624a51255bcc3e76356905b4135"
  license "Apache-2.0"
  head "https://github.com/openziti/zrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd3a231757b5273262a11022f6de1ce152e3525a30389516df7cede0680fa04b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e58251c7477f402db5dc4c3dc6bec4e16f38017f19c3cb936432e76df0899898"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e756df2133c1a3b5245b3203fd66f4107ff1b6760bcb4f0688db7ef455396670"
    sha256 cellar: :any_skip_relocation, ventura:        "f41d5c00b3a8c8e288b2765ac18ed88c31531fb824c3bed33a017e464bad552f"
    sha256 cellar: :any_skip_relocation, monterey:       "ddcd1ebbd8666e84e6ca8f7bfbf0ddf7045e41001d3048b04912d4248cfda5cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "b962ef81e15b8327dfdf2299b15da31c3ff336bd98e41987072eb33d436dcfbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed6026a235ed0d6da509cb1ab040d2a4283f20c76a4ac10f7a957549fcded45c"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd buildpath/"ui" do
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "build"
    end
    ldflags = ["-X github.com/openziti/zrok/build.Version=#{version}",
               "-X github.com/openziti/zrok/build.Hash=brew"]
    system "go", "build", *std_go_args(ldflags: ldflags), "github.com/openziti/zrok/cmd/zrok"
  end

  test do
    (testpath/"ctrl.yml").write <<~EOS
      v: 2
      maintenance:
        registration:
          expiration_timeout: 24h
    EOS

    version_output = shell_output("#{bin}/zrok version")
    assert_match(version.to_s, version_output)
    assert_match(/[[a-f0-9]{40}]/, version_output)

    status_output = shell_output("#{bin}/zrok controller validate #{testpath}/ctrl.yml 2>&1")
    assert_match("expiration_timeout = 24h0m0s", status_output)
  end
end
