class Starfig < Formula
  desc "Programmatic and deterministic config generator, using Starlark"
  homepage "https://github.com/jathu/starfig"
  url "https://github.com/jathu/starfig/archive/refs/tags/0.1.tar.gz"
  sha256 "c068e394ec204055edc8b1c33f325b0ad182b4abaa45193cbe36cd812179a09d"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.starfigVersion=#{version}", "-o", bin/"starfig"
  end

  test do
    make_test_file("STARVERSE", "")
    defs_content = <<~EOF
      Greeter = Schema(
        fields = {
          "message": String()
        }
      )
    EOF
    make_test_file(File.join("example", "defs.star"), defs_content)
    starfig_content = <<~EOF
      load("//example/defs.star", "Greeter")

      hello = Greeter(message = "hello world")
    EOF
    make_test_file(File.join("example", "STARFIG"), starfig_content)

    build_result = `#{bin}/starfig build //...`.strip
    expected_result = '{"//example:hello": {"message": "hello world"}}'

    system "false" if build_result != expected_result
  end

  def make_test_file(filename, content)
    file_path = File.join(testpath, filename)
    directory = File.dirname(file_path)
    Dir.mkdir(directory) unless File.exist?(directory)
    File.write(file_path, content)
    file_path
  end
end
