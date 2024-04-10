class Muscle < Formula
  desc "Multiple sequence alignment tool"
  homepage "https://github.com/rcedgar/muscle"
  url "https://github.com/rcedgar/muscle/archive/refs/tags/v5.1.tar.gz"
  sha256 "2fe55db73ff4e3e1cb6429a7a365e4546f333200a2bb8d32f21e4cce833b92a8"
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
