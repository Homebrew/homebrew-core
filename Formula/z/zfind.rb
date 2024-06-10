class Zfind < Formula
  desc "Search for files (even inside tar/zip/7z/rar) using a SQL-WHERE filter"
  homepage "https://github.com/laktak/zfind"
  url "https://github.com/laktak/zfind/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "66dd6a6e88c651767b2b721226367d8a1211adc3662a04e5b9febf5e43d42ebe"
  license "MIT"
  head "https://github.com/laktak/zfind.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c184d605e8b41433236f6bb21e1d40b09cca2d42f887b5255f59d98f7cf13173"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13524999e3a6a7f5fa4f221eca2273ea738923a2c62ed0eb359081a8f6ee7a3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b89a477666076fa2e6d5eee6062cb49f1a9ba37db5ba24cff354818855afa4d"
    sha256 cellar: :any_skip_relocation, sonoma:         "1b4de8cad247b3decb50d90889d66d4b811e27eb1975e1c364b684a30c800a6f"
    sha256 cellar: :any_skip_relocation, ventura:        "958496523ee35192461c0db8d0b5b96f67ea02617b00a65b7bca4733fbda5176"
    sha256 cellar: :any_skip_relocation, monterey:       "6902247ee9cffb051364d14708e0913d5358488b9beae0791a9d3c2db23ff2fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fe6ceb6f161eab1f7095c4b30c8813e8f79a0ce27c35db5f7d927a3ec959e90"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.appVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/zfind"
  end

  test do
    output = shell_output("#{bin}/zfind --csv")
    assert_match "name,path,container,size,date,time,type,archive", output

    assert_match version.to_s, shell_output("#{bin}/zfind --version")
  end
end
