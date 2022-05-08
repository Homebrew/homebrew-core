# Documentation: https://github.com/Mikaelemmmm/sql2pb
class Sql2pb < Formula
  desc "Generates a protobuf file from your mysql database"
  homepage "https://github.com/Mikaelemmmm/sql2pb"
  url "https://github.com/Mikaelemmmm/sql2pb/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "9ed48666f7863589246c0dad4f8b95f7ed093304f1f60d0e127e37ca7b12363b"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"sql2pb"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test sql2pb`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
