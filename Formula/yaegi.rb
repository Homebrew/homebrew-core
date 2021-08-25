class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.9.23.tar.gz"
  sha256 "52394e495b36b87d67f40b9104889da3e50eda5dfe5dc5b9eb2795e40c4be135"
  license "Apache-2.0"
  head "https://github.com/containous/yaegi.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fd585f269348a457fa22780f23302e91d9a8541a796a8f00e5478be3643452ff"
    sha256 cellar: :any_skip_relocation, big_sur:       "f951ab445e8fbd81f9009c8bd674d7b223b4a396cf8a747a41ddb8f3be823b03"
    sha256 cellar: :any_skip_relocation, catalina:      "c05353aacaa24d9d9b50ca218c181518ee5ea513f68d11c8a9be721c910e1e80"
    sha256 cellar: :any_skip_relocation, mojave:        "5d7b8703e0093b4619d04f30971eb946aeefee0206a93ca15dc0409419615e27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "584ba4a03a0787fd74620cc8e71af14167993c7737150dd21fe790e0904cd7de"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X=main.version=#{version}"), "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
