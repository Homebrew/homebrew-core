class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/v0.3.2.tar.gz"
  sha256 "8250692165937e1060ab3c94f6d4742658873073ca08ee50f6d546c7b84807ff"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    sample_recording = <<~EOS
      H4sICCOlhlsAA2JyZXdfdGVzdF9yZXN1bHQAvdHBCsIwDAbgu08hOQ/nHKgM8S08iYy0Vlds0
      5J2Dhl7d3eZTNxN8Rb4yf9BwiL4xzKbtRAZpYLi2AKh7QfYyfmlJhm1oz0kwMpg1HdVeoxVH9
      d0I9dQn6AIztRxSKg2JgGjSZGDYtklr0ZEnCgKleNYenZXRrtg8dkI6SEoDmnlrEoFqyYNaL1
      R70uDuBqJQogpcWL7K3I9IqWU/yCz8WF3FvXkk37P5t0pAa/PUOTbfLvpZk/I+tcWQgIAAA==
    EOS

    expected_result = "100.00   100.00  aaa - short_program.rb"

    File.open("recording.gz", "wb") do |f|
      f.write(Base64.decode64(sample_recording.delete("\n")))
    end

    shell_output("#{bin}/rbspy report -f summary -i recording.gz -o result")

    assert_includes File.read("result"), expected_result
  end
end
