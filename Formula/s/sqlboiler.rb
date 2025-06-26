class Sqlboiler < Formula
  desc "Generate a Go ORM tailored to your database schema"
  homepage "https://github.com/volatiletech/sqlboiler"
  url "https://github.com/volatiletech/sqlboiler/archive/refs/tags/v4.19.4.tar.gz"
  sha256 "8eae1aef6445aee4234271578636baf05f71909a7f8e3f5a2dad326fd7f1a958"
  license "BSD-3-Clause"
  head "https://github.com/volatiletech/sqlboiler.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b4add434e7c891fa931251afed3a07c682f5fd25e1f87b744f3a2e851e5c2af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b4add434e7c891fa931251afed3a07c682f5fd25e1f87b744f3a2e851e5c2af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b4add434e7c891fa931251afed3a07c682f5fd25e1f87b744f3a2e851e5c2af"
    sha256 cellar: :any_skip_relocation, sonoma:        "76ca857d4f6e7247dded84268526b81f06e95b2d51c8146ea832d2f90bd3efb2"
    sha256 cellar: :any_skip_relocation, ventura:       "76ca857d4f6e7247dded84268526b81f06e95b2d51c8146ea832d2f90bd3efb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c776177db9bc32682c923be3f363fcbb99129799e9f518088322ce14458b078d"
  end

  depends_on "go" => :build

  # version patch, upstream pr ref, https://github.com/aarondl/sqlboiler/pull/1456
  patch do
    url "https://github.com/aarondl/sqlboiler/commit/f8a886bf1910cb79ab424e67957c291f5879db6a.patch?full_index=1"
    sha256 "010a91f9662400638682b17aec518b80c3e641e9973cb9b7e4e3f7b9602ba8f4"
  end

  def install
    %w[mssql mysql psql sqlite3].each do |driver|
      f = "sqlboiler-#{driver}"
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/f), "./drivers/#{f}"
    end

    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/sqlboiler psql 2>&1", 1)
    assert_match "failed to find key user in config", output

    assert_match version.to_s, shell_output("#{bin}/sqlboiler --version")
  end
end
