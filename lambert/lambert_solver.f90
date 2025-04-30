program lambert_solver
    use kind_module, only: wp                  ! Define working precision wp (from kind_module)
    use lambert_module, only: solve_lambert_izzo
    implicit none

    real(wp) :: r1(3), r2(3), mu, dt
    real(wp), allocatable :: v1(:,:), v2(:,:)
    logical :: status_ok
    integer :: ios, line_count, i = 0
    integer, parameter :: in_id = 10, out_id = 09
    character(len=256) :: line

    ! Display
    print "(A)", "    Solving lambert's problem."

    ! Open files
    open(unit=out_id, file="lambert/lambert_output.dat", status="replace", action="write")
    open(unit=in_id, file='lambert/lambert_input.dat', status='old', action='read')

    ! Count lines
    line_count = 0
    do
      read(in_id, '(A)', iostat=ios) line
      if (ios /= 0) exit
      line_count = line_count + 1
    end do
    print "(A, I0)", "        Number of points to solve for: ", line_count
    rewind(in_id) ! Rewind to read again

    i = 0
    do
      read(in_id, *, iostat=ios) r1(1), r1(2), r1(3), r2(1), r2(2), r2(3), dt, mu
      if (ios /= 0) exit  ! Exit loop on end-of-file or error

      call solve_lambert_izzo(r1, r2, dt, mu, .false., 0, v1, v2, status_ok)
      write(out_id, "(3F15.6)", advance="no") v1(1,1), v1(2,1), v1(3,1)
      call solve_lambert_izzo(r1, r2, dt, mu, .true., 0, v1, v2, status_ok)
      write(out_id, "(3F15.6)") v1(1,1), v1(2,1), v1(3,1)

      ! Display
      if(mod(i, int(1e4))==0) then
        print "(A,F6.2,A)", "        Progress: ", float(i)*100.0/float(line_count-2), " %"
        !write(*,'(A,F6.2,A)', advance='no') achar(13)//'        Progress: ', float(i)*100.0/float(line_count-2), ' %'
        !write(*,'(A)', advance='no') char(27)//'[2K'//char(13)//'Progress: '//trim(adjustl("asassd"))
      end if
      i = i+1
    end do

    ! Display
    print "(A)", "    Finish solving."

    ! Close files
    close(in_id)
    close(out_id)
  
  end program lambert_solver
  