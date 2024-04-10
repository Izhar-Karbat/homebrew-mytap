class Muscle < Formula
  desc "Multiple sequence alignment tool"
  homepage "https://github.com/rcedgar/muscle"
  url "https://github.com/rcedgar/muscle/archive/refs/tags/v5.1.tar.gz"
  sha256 "sha256 "091d9f8733b92ff106c2a8eb274d1e5a57960d397a2068d8638d6002e8880dab""
  license "GPL-3.0-only"

  depends_on "libomp"

  def install
    ENV.cxx11
    libomp = Formula["libomp"]

    # Point to the libomp headers and library
    ENV.append_to_cflags "-I#{libomp.opt_include}"
    ENV.append "LDFLAGS", "-L#{libomp.opt_lib} -lomp"

    # Compile using Clang instead of GCC
    inreplace "src/Makefile", "CXX := g++", "CXX := #{ENV.cxx}"

    # Remove the -static flag from the Makefile
    inreplace "src/Makefile", "-static", ""

    # Build and install
    cd "src" do
      system "make"
      bin.install "muscle"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/muscle -version")
  end
end
